import Service from '@ember/service';
import { registerDestructor } from '@ember/destroyable';
import type Owner from '@ember/owner';

/**
 * A key handler. `count` is the number typed before the key (1 if none) and
 * `partKey` the last part letter typed (Q W E R A S D F, '' if none).
 * Return true to preventDefault, e.g. to stop arrows scrolling the page.
 */
export type KeyHandler = (count: number, partKey: string) => boolean | void;
export type KeyBindings = Record<string, KeyHandler>;

const NAMED_KEYS: Record<string, string> = {
  ' ': 'space',
  ArrowLeft: 'left',
  ArrowUp: 'up',
  ArrowRight: 'right',
  ArrowDown: 'down',
  Backspace: 'backspace',
};

/** "ctrl+shift+left", "shift+?", "c", "2"... as the bindings name them. */
export function keyCombo(event: KeyboardEvent): string | undefined {
  const key =
    NAMED_KEYS[event.key] ??
    (event.key.length === 1 ? event.key.toLowerCase() : undefined);
  if (!key) return undefined;
  let combo = key;
  if (event.shiftKey) combo = `shift+${combo}`;
  if (event.ctrlKey) combo = `ctrl+${combo}`;
  return combo;
}

function isEditable(target: EventTarget | null): boolean {
  return (
    target instanceof HTMLElement &&
    (target.isContentEditable ||
      ['INPUT', 'SELECT', 'TEXTAREA'].includes(target.tagName))
  );
}

/**
 * The app's vim-style keyboard commands. Digits typed before a command are a
 * count ("2 0 b" sets 20 beats) and a part letter picks which part it applies
 * to ("w m" mutes part W). Components register bindings while rendered.
 */
export default class KeyboardService extends Service {
  private layers: KeyBindings[] = [];
  private digits = '';
  private partKey = '';

  constructor(owner: Owner) {
    super(owner);
    const onKeyDown = (event: KeyboardEvent) => this.handle(event);
    document.addEventListener('keydown', onKeyDown);
    registerDestructor(this, () =>
      document.removeEventListener('keydown', onKeyDown),
    );
  }

  /** Adds bindings until the returned function is called. Later wins. */
  register(bindings: KeyBindings): () => void {
    this.layers = [...this.layers, bindings];
    return () => {
      this.layers = this.layers.filter((layer) => layer !== bindings);
    };
  }

  private handlerFor(combo: string): KeyHandler | undefined {
    for (let i = this.layers.length - 1; i >= 0; i--) {
      const handler = this.layers[i]![combo];
      if (handler) return handler;
    }
    return undefined;
  }

  handle(event: KeyboardEvent): void {
    if (isEditable(event.target)) return;
    const combo = keyCombo(event);
    if (!combo) return;

    if (/^\d$/.test(combo)) this.digits += combo;
    if (/^[qwerasdf]$/.test(combo)) this.partKey = combo.toUpperCase();

    const handler = this.handlerFor(combo);
    if (!handler) return;
    const count = this.digits ? parseInt(this.digits, 10) : 1;
    const partKey = this.partKey;
    this.digits = '';
    this.partKey = '';
    if (handler(count, partKey) === true) event.preventDefault();
  }
}

declare module '@ember/service' {
  interface Registry {
    keyboard: KeyboardService;
  }
}

import {
  click,
  find,
  findAll,
  triggerEvent,
  triggerKeyEvent,
  visit,
} from '@ember/test-helpers';

const STORAGE_KEY = 'seq25';

// ---------------------------------------------------------------- storage

/** Starts each test with empty song storage, and cleans up after it. */
export function setupStorage(hooks: NestedHooks): void {
  hooks.beforeEach(() => localStorage.removeItem(STORAGE_KEY));
  hooks.afterEach(() => localStorage.removeItem(STORAGE_KEY));
}

export function storeSongs(db: unknown): void {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(db));
}

export function storedSongs(): unknown {
  return JSON.parse(localStorage.getItem(STORAGE_KEY) ?? 'null');
}

// ---------------------------------------------------------------- backend

export interface FakeRequest {
  method: string;
  url: string;
  body: unknown;
}

type Responder = (request: FakeRequest) => unknown;

/**
 * Replaces fetch with canned JSON responses, keyed "METHOD /path". The song
 * list answers [] unless a test says otherwise. Unmatched requests 404.
 */
export function setupBackend(hooks: NestedHooks): {
  routes: Record<string, Responder>;
  requests: FakeRequest[];
} {
  const state = {
    routes: {} as Record<string, Responder>,
    requests: [] as FakeRequest[],
  };
  let realFetch: typeof fetch;

  hooks.beforeEach(() => {
    state.routes = { 'GET /songs': () => [] };
    state.requests = [];
    realFetch = window.fetch.bind(window);
    window.fetch = (input, init) => {
      const href = input instanceof Request ? input.url : input.toString();
      const url = new URL(href, location.href).pathname;
      const method = (init?.method ?? 'GET').toUpperCase();
      const body: unknown =
        typeof init?.body === 'string' ? JSON.parse(init.body) : undefined;
      const request = { method, url, body };
      state.requests.push(request);
      const responder = state.routes[`${method} ${url}`];
      return Promise.resolve(
        responder
          ? Response.json(responder(request))
          : new Response('not found', { status: 404 }),
      );
    };
  });
  hooks.afterEach(() => {
    window.fetch = realFetch;
  });
  return state;
}

// ---------------------------------------------------------------- keyboard

const KEY_NAMES: Record<string, string> = {
  space: ' ',
  left: 'ArrowLeft',
  right: 'ArrowRight',
  up: 'ArrowUp',
  down: 'ArrowDown',
  backspace: 'Backspace',
};

/** Types key combos as the bindings name them: press('2, 0, b'). */
export async function press(keys: string): Promise<void> {
  for (const combo of keys.split(',').map((k) => k.trim())) {
    const parts = combo.split('+');
    const name = parts.pop()!;
    // triggerKeyEvent wants letters capitalized; the app lowercases them.
    const key = KEY_NAMES[name] ?? name.toUpperCase();
    await triggerKeyEvent(document.body, 'keydown', key, {
      shiftKey: parts.includes('shift'),
      ctrlKey: parts.includes('ctrl'),
    });
  }
}

// ---------------------------------------------------------------- the grid

/** A new song with part Q open, where most tests start. */
export async function startPart(): Promise<void> {
  await visit('/');
  await click('#songs > button');
  await click('#parts li.empty');
}

/** An element's inline style as a property map. */
export function styles(selector: string): Record<string, string> {
  const style = find(selector)?.getAttribute('style') ?? '';
  return Object.fromEntries(
    style
      .split(';')
      .map((declaration) => declaration.split(':').map((s) => s.trim()))
      .filter((pair): pair is [string, string] => pair.length === 2),
  );
}

export const note = (n = 1) => `#grid .notes li:nth-child(${n})`;
export const left = (n = 1) => styles(note(n))['left'];
export const width = (n = 1) => styles(note(n))['width'];
export const top = (n = 1) => styles(note(n))['top'];
export const notesCount = () => findAll('#grid .notes li').length;
export const selectedCount = () => findAll('#grid .notes li.selected').length;

/** Presses and releases the mouse at an offset (px) into an element. */
export async function clickAt(
  selector: string,
  { x = 0, y = 0, shiftKey = false } = {},
): Promise<void> {
  const element = find(selector);
  if (!element) throw new Error(`${selector} not found`);
  const rect = element.getBoundingClientRect();
  const options = { clientX: rect.left + x, clientY: rect.top + y, shiftKey };
  await triggerEvent(element, 'mousedown', options);
  await triggerEvent(element, 'click', options);
  await triggerEvent(element, 'mouseup', options);
}

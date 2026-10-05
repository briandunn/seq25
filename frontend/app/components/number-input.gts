import { on } from '@ember/modifier';
import type { TOC } from '@ember/component/template-only';

/** Calls @onChange with the number typed (ignoring an empty field). */
function changed(onChange: (value: number) => void) {
  return (event: Event) => {
    const { value } = event.target as HTMLInputElement;
    const number = Number(value);
    if (value !== '' && Number.isFinite(number)) onChange(number);
  };
}

const NumberInput: TOC<{
  Args: {
    value: number;
    onChange: (value: number) => void;
    min?: number;
    max?: number;
    step?: number;
  };
  Element: HTMLInputElement;
}> = <template>
  <input
    type="number"
    min={{@min}}
    max={{@max}}
    step={{@step}}
    value={{@value}}
    {{on "input" (changed @onChange)}}
    ...attributes
  />
</template>;

export default NumberInput;

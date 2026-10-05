import { on } from '@ember/modifier';
import type { TOC } from '@ember/component/template-only';

function changed(onChange: (value: number) => void) {
  return (event: Event) =>
    onChange(Number((event.target as HTMLInputElement).value));
}

const RangeInput: TOC<{
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
    type="range"
    min={{if @min @min 0}}
    max={{if @max @max 1}}
    step={{if @step @step 0.01}}
    value={{@value}}
    {{on "input" (changed @onChange)}}
    ...attributes
  />
</template>;

export default RangeInput;

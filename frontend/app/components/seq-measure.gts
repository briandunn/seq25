import { htmlSafe } from '@ember/template';

const measureStyle = (beatCount: number) =>
  htmlSafe(`width: ${100 / beatCount}%`);

<template>
  <li class="measure" style={{measureStyle @beatCount}} ...attributes></li>
</template> satisfies import('@ember/component/template-only').TOC<{
  Args: { beatCount: number };
  Element: HTMLLIElement;
}>;

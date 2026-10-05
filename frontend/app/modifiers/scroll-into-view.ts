import { modifier } from 'ember-modifier';

/**
 * Scrolls the page to an element that's off screen, when it renders and
 * whenever `key` changes (a note moving to another pitch).
 */
export default modifier<{
  Element: HTMLElement;
  Args: { Positional: [key: unknown] };
}>((element) => {
  // Modifiers run once the element is in the DOM, so it can be measured.
  if (!element.isConnected) return;
  const { top, bottom } = element.getBoundingClientRect();
  if (bottom < 0 || top > window.innerHeight) {
    element.scrollIntoView({ block: 'center' });
  }
});

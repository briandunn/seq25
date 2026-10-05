/** Five-character random ids, the same shape the old localStorage adapter used. */
export default function generateId(): string {
  return Math.random().toString(32).slice(2, 7);
}

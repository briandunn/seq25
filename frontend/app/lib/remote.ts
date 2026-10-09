import config from 'seq25/config/environment';

export interface RemoteSongRef {
  id: string;
}

async function json(response: Response): Promise<unknown> {
  if (!response.ok) {
    throw new Error(`${response.url}: ${response.status}`);
  }
  return response.json();
}

/** Songs shared to the backend (only the latest version of each). */
export async function listRemote(): Promise<RemoteSongRef[]> {
  const body = await json(await fetch(config.serverURL));
  return Array.isArray(body) ? (body as RemoteSongRef[]) : [];
}

export async function fetchRemote(id: string): Promise<unknown> {
  return json(await fetch(`${config.serverURL}/${encodeURIComponent(id)}`));
}

/** Shares a song; resolves to the id the backend gave it. */
export async function sendRemote(payload: unknown): Promise<number> {
  const body = await json(
    await fetch(config.serverURL, {
      method: 'POST',
      headers: { 'content-type': 'application/json; charset=utf-8' },
      body: JSON.stringify(payload),
    }),
  );
  const id = Number((body as { id?: unknown } | null)?.id);
  if (!Number.isFinite(id)) throw new Error('backend returned no song id');
  return id;
}

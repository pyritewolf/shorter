import { derived } from 'svelte/store';
import { user } from "./user";

export enum APIStatus {
  ok = "ok",
  error = "error",
};

type APIResponse = {
  status: APIStatus;
  body: any;
}

export const api = derived(user, $user => {
  const method = async (path: string, options: any = { headers: {}}): Promise<APIResponse | null> => {
    let token = localStorage.getItem('token');
    if (!token) {
      token = (new URLSearchParams(window.location.search)).get("token");
      if (token)
        localStorage.setItem('token', token);
    }
    const opts = {...options}
    if (token) 
      opts.headers = {
        'Authorization': `Bearer ${token}`,
        ...(options.headers),
      };
    if (opts.body)
      opts.headers = {
        'Content-Type': 'application/json',
        ...(opts.headers),
      }
    const response = await fetch(path, opts);
    if (response.status === 401) {
      user.update(() => {
        localStorage.removeItem('token');
        return null
      })
    }

    let status = APIStatus.ok;
    if (response.status < 200 || response.status >= 300)
      status = APIStatus.error;
    const body = await response.json();
    return { status, body };
  };
  return method;
});

import { readable } from 'svelte/store';
import type { User } from '../components/types';

export const user = readable({}, async function start(set) {
	const response : User = await (await fetch('/api/me', {
    headers: new Headers({'Authorization': `Bearer ${localStorage.getItem('token')}`})
  })).json();
  set(response);

	return function stop() {
		set({});
	};
});

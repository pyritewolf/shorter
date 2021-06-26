import { readable } from 'svelte/store';

export const user = readable({}, async function start(set) {
	const response = await (await fetch('/api/me', {
    headers: new Headers({'Authorization': `Bearer ${localStorage.getItem('token')}`})
  })).json();
  set(response);

	return function stop() {
		set({});
	};
});

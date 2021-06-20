import { readable } from 'svelte/store';

export const settings = readable({}, async function start(set) {
	const response = await (await fetch('/api/settings')).json();
  set(response);

	return function stop() {
		set({});
	};
});

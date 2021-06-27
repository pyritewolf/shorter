import { readable } from 'svelte/store';
import type { Settings } from "../components/types";

export const settings = readable({}, async function start(set) {
	const response : Settings = await (await fetch('/api/settings')).json();
  set(response);

	return function stop() {
		set({});
	};
});

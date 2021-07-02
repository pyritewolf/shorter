import { derived } from 'svelte/store';
import { api } from './api';
import type { Settings } from "../components/types";

export const settings = derived<Settings>(api, async $api => {
	return (await $api('/api/settings')).body;
});

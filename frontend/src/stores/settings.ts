import { derived } from 'svelte/store';
import { api } from './api';

export const settings = derived(api, async $api => {
	return (await $api('/api/settings')).body;
});

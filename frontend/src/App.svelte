<script lang="ts">
	import {onMount} from "svelte";
	import { api, APIStatus } from "./stores/api";
	import { user } from './stores/user';
	import Home from './views/Home.svelte';
	import LogIn from './views/LogIn.svelte';

	onMount(async () => {
		const response = await $api('/api/me');
		if (response.status === APIStatus.ok)
			user.set(response.body);
	});
</script>

<main>
	{#if $user}
		<Home />
	{:else}
		<LogIn />
	{/if}
</main>

<style>
	main {
		min-height: 100vh;
		max-width: 128rem;
		margin: auto;
		padding: var(--gap-xl);
	}
</style>

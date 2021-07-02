<script lang="ts">
	import Loading from "./components/Loading.svelte";
	import { api, APIStatus } from "./stores/api";
	import { user } from './stores/user';
	import Home from './views/Home.svelte';
	import LogIn from './views/LogIn.svelte';

	const loadUserData = async () => {
		const response = await $api('/api/me');
		if (response.status === APIStatus.ok)
			user.set(response.body);
	};
</script>

<main>
	{#await loadUserData()}
		<Loading />
	{:then}
		{#if $user}
			<Home />
		{:else}
			<LogIn />
		{/if}
	{/await}
</main>

<style>
	main {
		min-height: 100vh;
		max-width: 128rem;
		margin: auto;
		padding: var(--gap-xl);
	}
</style>

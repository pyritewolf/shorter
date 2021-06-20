<script lang="ts">
	import {onMount} from 'svelte';
	import Home from './views/Home.svelte';
	import LogIn from './views/LogIn.svelte';

	let isLoggedIn = false;

	onMount(() => {
		let token = localStorage.getItem('token')
		if (!token) {
			token = (new URLSearchParams(window.location.search)).get("token");
			if (token)
				localStorage.setItem('token', token);
		}
		isLoggedIn = !!token;
	});
</script>

<main>
	{#if isLoggedIn}
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

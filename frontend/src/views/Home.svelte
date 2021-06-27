<script lang="ts">
	import {onMount} from 'svelte';
	import Button from '../components/form/Button.svelte';
	import Input from '../components/form/Input.svelte';
	import {Color} from '../types'
  import { settings } from '../stores/settings';
  import { user } from '../stores/user';
  import Url from '../components/Url.svelte';
	
  const initialFormData = () => ({
    path: "",
		redirect_to: "",
	});

	let formData = initialFormData();
	let urls = [];
	
	const handleSubmit = async () => {
		await fetch('/api/url', {
			method: "POST",
			body: JSON.stringify(formData),
			headers: new Headers({
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }),
		});
    formData = initialFormData();
    await getURLs();
	};
	
	const getURLs = async () => {
		urls = await (await fetch('/api/url', {
      headers: new Headers({'Authorization': `Bearer ${localStorage.getItem('token')}`})
    })).json()
	};

	onMount(async () => await getURLs());
</script>
<form on:submit|preventDefault={handleSubmit}>
  <Input placeholder="your url" bind:value={formData.redirect_to}/> 
  <Input placeholder="the path you want it to have" bind:value={formData.path}/> 
  <Button color={Color.transparent}>Shorten</Button>
</form>
<div class="list">
  <div class="col header">
    <span>URL</span>
    <span>Shortened URL</span>
  </div>
  {#each urls as url}
    <Url {url} settings={$settings} isOwn={$user.id === url.user_id} onAction={getURLs}/>
  {:else}
    No URLs shortened so far
  {/each}
</div>

<style>
	form {
		display: grid;
		grid-template-columns: 2fr 2fr 1fr;
		margin-bottom: var(--gap-md);
		gap: var(--gap-md)
	}

	form > :global(*) {
		flex-basis: 50%;
	}

	.list {
		padding: var(--gap-md);
		background-color: var(--darkest-gray);
		border-radius: var(--radius);
	}

	.list .col {
		display: grid;
		grid-template-columns: 5fr 2fr 1fr;
		padding: var(--gap-xs);
    grid-column-gap: var(--gap-md);
	}
  
	.list .col.header {
    text-transform: uppercase;
		letter-spacing: 1px;
		border-bottom: 1px solid var(--dark-gray);
		font-weight: bold;
		font-size: var(--font-sm);
	}
</style>

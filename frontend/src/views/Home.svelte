<script lang="ts">
	import {onMount} from 'svelte';
	import Button from '../components/form/Button.svelte';
	import Input from '../components/form/Input.svelte';
	import {Color} from '../types'
  import { settings } from '../stores/settings';
  import { user } from '../stores/user';
  import Url from '../components/Url.svelte';
import Toggle from '../components/form/Toggle.svelte';
import { InputType } from '../components/types';
	
  const initialFormData = () => ({
    path: "",
		redirect_to: "",
		is_private: false,
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
	<Input
		required
		name="new-url"
		label="Long URL"
		placeholder="https://yourSuperDuperLong.Url/withWeirdSymbols/andSuperBoringDetails" 
		bind:value={formData.redirect_to}
		type={InputType.url}
		/> 
  <Input
		required
		name="new-path"
		label="Path"
		pre={`${$settings.shortUrl}/`}
		placeholder="the path you want it to have"
		pattern={"[a-zA-Z0-9_\-]{3,}"}
		bind:value={formData.path}
		help="At least 3 characters, only letters, numbers, hyphens and underscores"
		/> 
	<Toggle name="private" bind:value={formData.is_private}>
		Make private
	</Toggle>
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
		display: flex;
		margin-bottom: var(--gap-md);
    align-items: flex-end;
		gap: var(--gap-md)
	}

	form > :global(*:nth-child(1)), form > :global(*:nth-child(2)) {
		flex-basis: 50%;
	}

	.list {
		padding: var(--gap-md);
		background-color: var(--darkest-gray);
		border-radius: var(--radius);
	}

	.list .col {
		display: grid;
		grid-template-columns: 2fr 2fr 1fr;
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

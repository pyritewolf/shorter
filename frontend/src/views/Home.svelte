<script lang="ts">
	import {onMount} from 'svelte';
	import Button from '../components/form/Button.svelte';
	import Input from '../components/form/Input.svelte';
	import {Color} from '../types'
  import { settings } from '../stores/settings';
  import { user } from '../stores/user';
  import Icon from '../components/Icon.svelte';
	import {ButtonType, IconName, Size} from '../components/types'
	
  const initialFormData = () => ({
    path: "",
		redirect_to: "",
	});

	let formData = initialFormData();
	let urls = [];
  let copiedID = '';
	
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

  const copyToClipboard = (selector : string) => {
    const copyText : HTMLInputElement = document.querySelector(`#${selector}`);
    copyText.select();
    document.execCommand("copy")
    copiedID = selector;
    setTimeout(() => copiedID = "", 3000)
  }

  const handleDelete = async (id) => {
		await fetch(`/api/url/${id}`, {
			method: "DELETE",
			headers: new Headers({
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }),
		});
    await getURLs();
  }

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
    <div class="col" on:click={() => copyToClipboard(`url-${url.id}`)}>
      <span>
        {url.redirect_to} 
        <input type="text" id={`url-${url.id}`} value={`https://${$settings.shortUrl}/${url.path}`} /></span>
      <span>
        {$settings.shortUrl}/<strong>{url.path}</strong>
        {#if copiedID === `url-${url.id}`}
          <span class="pill">
            Copied!
          </span>
        {/if}
      </span>
      {#if url.user_id == $user.id}
        <span>
          <Button type={ButtonType.button} size={Size.sm} click={() => handleDelete(url.id)}>
            <span  slot="icon" >
              <Icon name={IconName.trash} />
            </span>
          </Button>
        </span>
      {/if}
    </div>		
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
		grid-template-columns: 2fr 1fr min-content;
		padding: var(--gap-xs);
    grid-column-gap: var(--gap-md);
	}

  .list .col span {
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    display: flex;
    align-items: center;
  }
  
	.list .col.header {
    text-transform: uppercase;
		letter-spacing: 1px;
		border-bottom: 1px solid var(--dark-gray);
		font-weight: bold;
		font-size: var(--font-sm);
	}
  
  .list .col:not(.header) {
    cursor: pointer;
		margin-top: var(--gap-xs);
    transition: var(--transition);
    border-radius: var(--radius);
  }

  .list .col:not(.header):hover {
    background-color: var(--darker-gray);
    transition: var(--transition);
  }

  .list .col .pill {
    background-color: var(--dark-secondary);
    padding: 0  var(--gap-xs);
    display: inline-block;
    margin-left: var(--gap-md);
    border-radius: var(--radius);
    font-size: var(--font-sm);
    text-transform: uppercase;
  }

  .list .col input {
    height: 0;
    overflow: hidden;
    padding: 0;
  }
</style>

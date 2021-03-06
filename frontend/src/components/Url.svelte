<script lang="ts">
  import Button from "./form/Button.svelte";
  import Icon from "./Icon.svelte";
  import { ButtonType, IconName, Size } from "./types";
  import type { Settings, URL } from "./types";
  import Toggle from "./form/Toggle.svelte";
  import { api } from "../stores/api";
  import { APIStatus, getErrorFor } from "../types";
  import type { APIError } from "../types";

  export let url : URL;
  export let shortUrl: string;
  export let isOwn : Boolean = false;
  export let onAction : Function;
	let formError: APIError | null = null;

  let copied = false;
  let enableEdit = false;
  let originalUrl = { ...url };

  const fallbackCopyTextToClipboard = (text) => {
    const textArea = document.createElement("textarea");
    textArea.value = text;
    
    // Avoid scrolling to bottom
    textArea.style.top = "0";
    textArea.style.left = "0";
    textArea.style.position = "fixed";

    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    document.execCommand('copy');
    document.body.removeChild(textArea);
  }

  const copyToClipboard = async () => {
    if (enableEdit) return;
    const text = `https://${shortUrl}/${url.path}`
    if (!navigator.clipboard)
      fallbackCopyTextToClipboard(text);
    else
      navigator.clipboard.writeText(text);
    copied = true;
    setTimeout(() => copied = false, 3000)
  }

  const handleDelete = async () => {
		const response = await $api(`/api/url/${url.id}`, {
			method: "DELETE",
		});
		if (response.status === APIStatus.ok)
      onAction();
  }

  const handleEdit = async () => {
    if (enableEdit) {
      const {status, body} = await $api(`/api/url/${url.id}`, {
        method: "PUT",
        body: JSON.stringify(url),
      });
      if (status === APIStatus.error) 
        return formError = body
      enableEdit = false;
      formError = null;
    }
    onAction();
  }

  const toggleEdit = () => {
    enableEdit = !enableEdit;
    formError = null;
    if (!enableEdit)
      url = {...originalUrl};
  }
</script>
<form on:click={copyToClipboard} title="Click to copy this shorter URL to your clipboard" on:submit|preventDefault={handleEdit}>
  <span>
    <input type="text"  bind:value={url.redirect_to} name="url-{url.id}-redirect_to" readonly={!enableEdit}/>
    {#if getErrorFor('redirect_to', formError)}
      <div class="error">
        {getErrorFor('redirect_to', formError)}
      </div>
    {/if}
  </span>
  <span>
    <div class="url">
      {shortUrl}/<input type="text" bind:value={url.path} name="url-{url.id}-path" readonly={!enableEdit}/>
      {#if copied}
        <span class="pill">
          Copied!
        </span>
      {/if}
      {#if enableEdit}
        <Toggle name="private" bind:value={url.is_private} size={Size.sm}>
          Make private
        </Toggle>
      {:else if url.is_private}
          <span class="pill">
            Private
          </span>
      {/if}
    </div>
    {#if getErrorFor('path', formError)}
      <div class="error">
        {getErrorFor('path', formError)}
      </div>
    {/if}
  </span>
  {#if isOwn}
    <div class="actions">
      {#if enableEdit}
        <Button size={Size.sm}>
          <span slot="icon" >
            <Icon name={IconName.send} />
          </span>
          Save
        </Button>
        <Button type={ButtonType.button} size={Size.sm} click={toggleEdit}>
          <span  slot="icon" >
            <Icon name={IconName.close} />
          </span>
        </Button>
      {:else}
        <Button type={ButtonType.button} size={Size.sm} click={toggleEdit}>
          <span  slot="icon" >
            <Icon name={IconName.edit} />
          </span>
        </Button>
        <Button type={ButtonType.button} size={Size.sm} click={handleDelete}>
          <span  slot="icon" >
            <Icon name={IconName.trash} />
          </span>
        </Button>
      {/if}
    </div>
  {/if}
</form>
<style>
  form {
		display: grid;
		grid-template-columns: 2fr 2fr 1fr;
		padding: var(--gap-xs);
    grid-column-gap: var(--gap-md);
    cursor: pointer;
		margin-top: var(--gap-xs);
    transition: var(--transition);
    border-radius: var(--radius);
  }

  form:hover {
    background-color: var(--darker-gray);
    transition: var(--transition);
  }

  form > span {
    display: flex;
    justify-content: center;
    flex-direction: column;
  }

  form .url, form .actions {
    display: flex;
    align-items: center;
  }

  .pill {
    background-color: var(--dark-secondary);
    padding: 0  var(--gap-xs);
    display: inline-block;
    margin-left: var(--gap-sm);
    border-radius: var(--font-sm);
    font-size: var(--font-sm);
    text-transform: uppercase;
  }

  input[type="text"] {
    width: 100%;
    border: 0;
    outline: 0;
    background: transparent;
    color: var(--white);
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    border-bottom: 1px solid var(--primary);
  }

  input[type="text"]:read-only {
    cursor: pointer;
    border: 0;
  }
  
  .url input[type="text"] {
    color: var(--secondary);
    transition: var(--transition);
    font-weight: bold;
    margin-right: var(--gap-md)
  }

  form:hover .url input[type="text"] {
    color: var(--primary);
    transition: var(--transition);
  }

  .actions {
    justify-content: flex-end;
    gap: var(--gap-xs);
  }

  .error {
    font-size: var(--font-sm);
  }
</style>

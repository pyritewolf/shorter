<script lang="ts">
import Button from "../components/form/Button.svelte";
import { ButtonType } from "../components/form/types";

</script>

<div class="root">
  <Button type={ButtonType.button} click={() => window.location.replace(`${window.location.href}api/oauth/google`)}>Log in</Button>
</div>

<style>
	.root {
    min-height: calc(100vh - var(--gap-xl) * 2);
    display: flex;
    align-items: center;
    justify-content: center;
  }
</style>

<script lang="ts">
  import { IconName } from "./types"
  import { Gap, Color } from "../types"
  export let name : IconName;
  export let size : Gap = Gap.md;
  export let color : Color = Color.white;
</script>
<i class="icon las la-{name}" style="--size: var({size}); --color: var({color})"></i>
<style>
  .icon {
    font-size: var(--size);
    color: var(--color);
  }
</style>

<script lang="ts">
  import { ButtonType } from "./types"
  import { Color } from "../../types"
  export let type : ButtonType = ButtonType.submit;
  export let color : Color = Color.darkestGray;
  export let textColor : Color = Color.white;
  export let click = () => {};

  let focused : boolean = false;
</script>
<style>
  .root {
    background-color: var(--color);
    border-radius: var(--radius);
    background-size: 300%;
    background-image: var(--gradient-cold);
    height: var(--input-height);
    transition: var(--transition);
  }

  .root.focused, .root:hover {
    animation: var(--gradient-animation);
  }
  
  button {
    padding: var(--gap-md);
    background-color: var(--color);
    color: var(--text-color);
    width: 100%;
    height: 100%;
    display: block;
    border-radius: var(--radius);
    text-align: center;
    cursor: pointer;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-weight: bold;
    transition: var(--transition);
  }

  button:hover, button:focus {
    background-color: transparent;
    color: var(--white);
    transition: var(--transition);
  }
</style>
<div class="root" class:focused style="--color: var({color}); --text-color: var({textColor})" on:click={click}>
  <button {type} 
    on:focus={() => focused = true}
    on:blur={() => focused = false}><slot/></button>
</div>

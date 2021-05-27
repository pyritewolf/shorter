<script lang="ts">
  import { InputType } from "./types"
  export let name : string = "";
  export let placeholder : string = "";
  export let type : InputType = InputType.text;
  export let value : string | number = "";
  export let label : string  = "";
  
  let inputElement;
  let focused : boolean = false;

  const handleInput = (e) => {
    // in here, you can switch on type and implement
    // whatever behaviour you need
    value = type.match(/^(number|range)$/)
      ? parseFloat(e.target.value)
      : e.target.value;
  };

  const setFocus = () => inputElement.focus();
</script>

<style>
  .root {
    background-color: var(--darkest-gray);
    border-radius: var(--radius);
    background-size: 300%;
    background-image: var(--gradient-warm);
    transition: var(--transition);
    height: var(--input-height);
    max-width: 100%;
  }
  
  .root.focused {
    transition: var(--transition);
    padding: 5px;
	  animation: var(--gradient-animation);
  }

  input {
    margin: 0;
    outline: 0;
    display: block;
    background-color: var(--darkest-gray);
    padding: var(--gap-md);
    border: none;
    width: 100%;
    border-radius: var(--radius);
    color: white;
  }
</style>

<div
  class="root"
  class:focused
  on:click={setFocus}>
  {#if label}<label for={name}>{label}</label>{/if}
  <input
    bind:this={inputElement}
    {type}
    {value}
    {placeholder}
    {name}
    on:focus={() => focused = true}
    on:blur={() => focused = false}
    on:input={handleInput} />
</div>

<script lang="ts">
  import { InputType } from "../types"
  export let name : string;
  export let placeholder : string = "";
  export let type : InputType = InputType.text;
  export let value : string | number = "";
  export let label : string  = "";
  export let required : boolean = false;
  export let pattern : string | null;
  export let pre : string | null;
  export let help : string | null;
  export let error : string | null;
  
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
  .field {
    height: var(--field-height);
  }

  .top {
    height: calc(var(--font-md) + var(--gap-xs));
    font-size: var(--font-sm);
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    padding: 0 var(--gap-xs) var(--gap-xs) var(--gap-xs);
  }

  label {
    font-weight: bold;
    font-size: var(--font-md);
    color: white;
  }

  label span {
    color: var(--dark-tertiary);
  }

  .top .help {
    color: transparent;
    transition: var(--transition);
  }

  .focused .top .help {
    color: var(--gray);
  }

  .top .errorMsg {
    color: var(--error);
  }

  .animation {
    background-color: var(--darkest-gray);
    border-radius: var(--radius);
    background-size: 300%;
    background-image: var(--gradient-warm);
    transition: var(--transition);
    height: var(--input-height);
    max-width: 100%;
  }
  
  .focused .animation {
    transition: var(--transition);
	  animation: var(--gradient-animation);
  }

  .focused.error .animation {
    background-image: var(--gradient-error);
  }

  .input {
    background-color: var(--darkest-gray);
    border-radius: var(--radius);
    padding: 2px;
    color: white;
    transition: var(--transition);
  }

  .focused .input {
    background-color: transparent;
  }

  .wrapper {
    background-color: var(--darkest-gray);
    display: flex;
    position: relative;
    width: 100%;
    padding: 0 calc(var(--gap-md) - 2px);
    border-radius: var(--radius);
    height: calc(var(--input-height) - 4px);
  }

  .wrapper input, .wrapper .pre {
    padding: calc(var(--gap-md) - 2px) 0;
    height: calc(var(--input-height) - 4px);
  }

  input {
    margin: 0;
    outline: 0;
    display: block;
    background-color: transparent;
    padding: 0;
    border: none;
    width: 100%;
    color: white;
  }
</style>
<div
  class="field"
  class:focused
  class:error={!!error}>
  <div class="top">
    {#if label}<label for={name}>
      {label}{#if required}<span> *</span>{/if}
    </label>{/if}
    {#if help && !error}
      <div class="help">{help}</div>
    {/if}
    {#if error}
      <div class="errorMsg">{error}</div>
    {/if}
  </div>
  <div
    class="animation"
    on:click={setFocus}>
    <div class="input">
      <div class="wrapper">
        {#if pre}
          <div class="pre">{pre}</div>
        {/if}
        <input
          bind:this={inputElement}
          {type}
          {value}
          {placeholder}
          {name}
          {required}
          {pattern}
          on:focus={() => focused = true}
          on:blur={() => focused = false}
          on:input={handleInput} />
      </div>
    </div>
  </div>
</div>

<script lang="ts">
  import { Size } from "../types";

  export let value : boolean = false;
  export let name : string;
  export let size : Size = Size.md;

  const sizeMapping = {
    small: {
      width: '3rem',
      height: '1.2rem',
      knob: '1.8rem',
    },
    medium: {
      width: '4rem',
      height: '1.8rem',
      knob: '2.6rem',
    },
  };

  const getStyle = () => Object.keys(sizeMapping[size]).map(key => `--${key}: ${sizeMapping[size][key]}`).join(";")

  const toggleValue = () => value = !value;
</script>
<div class="toggle" on:click={toggleValue} style={getStyle()}>
  <div class="wrapper">
    <div class="slide" class:active={value} />
    <label for={name}><slot /></label>
  </div>
  <input type="checkbox" bind:value={name} checked={value} {name} />
</div>
<style>
  .toggle {
    --overflow: calc((var(--knob) - var(--height)) / 2);
    min-width: fit-content;
    height: var(--knob);
    display: flex;
    align-items: center;
  }
  
  .wrapper {
    padding-left: var(--overflow);
    display: flex;
    gap: var(--gap-sm);
    align-items: center;
    cursor: pointer;
    min-width: fit-content;
  }

  .toggle input {
    visibility: hidden;
    height: 0;
    width: 0;
    overflow: hidden;
    margin: 0;
  }

  .toggle label {
    cursor: pointer;
  }

  .slide {
    width: var(--width);
    height: var(--height);
    border-radius: calc(var(--height) / 2);
    background-color: var(--gray);
    transition: var(--transition);
    position: relative;
  }

  .slide.active {
    background-color: var(--primary);
  }

  .slide::before {
    content: "";
    display: block;
    width: var(--knob);
    height: var(--knob);
    background-color: var(--dark-gray);
    position: absolute;
    margin-left: calc(var(--overflow) * -1);
    margin-top: calc(var(--overflow) * -1);
    border-radius: calc(var(--knob) / 2);
    transition: var(--transition);
  }

  .slide.active::before {
    background-color: var(--dark-primary);
    position: absolute;
    margin-left: calc(100% - var(--knob) + var(--overflow));
  }
</style>

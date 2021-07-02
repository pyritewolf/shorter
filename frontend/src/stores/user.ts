import { writable } from 'svelte/store';
import type {  User } from '../components/types';

export const user = writable<User | null>(null);

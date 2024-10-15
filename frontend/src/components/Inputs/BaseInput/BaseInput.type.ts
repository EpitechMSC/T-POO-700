import { PropType } from 'vue';

export const BaseInputProps = {
  modelValue: {
    type: String,
    required: true,
  },
  label: {
    type: String,
    required: false,
  },
  type: {
    type: String as PropType<'text' | 'email' | 'password'>,
    default: 'text',
  },
  name: {
    type: String,
    required: true,
  },
  id: {
    type: String,
    required: true,
  },
  placeholder: {
    type: String,
    required: false,
  },
  required: {
    type: Boolean,
    default: false,
  },
  darkMode: {
    type: Boolean,
    default: false,
  },
  error: {
    type: String,
    required: false,
  },
};

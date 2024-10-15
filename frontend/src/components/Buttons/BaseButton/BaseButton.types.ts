import { PropType } from 'vue';

export const BaseButtonProps = {
  type: {
    type: String as PropType<'button' | 'submit' | 'reset'>,
    default: 'button',
  },
  disabled: {
    type: Boolean,
    default: false,
  },
  variant: {
    type: String as PropType<'primary' | 'secondary' | 'danger'>,
    default: 'primary',
  },
  fullWidth: {
    type: Boolean,
    default: false,
  },
};

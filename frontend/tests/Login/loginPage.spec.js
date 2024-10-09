// __tests__/LoginPage.spec.js
import { mount } from '@vue/test-utils';
import LoginPage from '../../src/pages/Login/LoginPage.vue';

describe('LoginPage.vue', () => {
  it('renders login form', () => {
    const wrapper = mount(LoginPage);
    expect(wrapper.text()).toContain('Connexion');
  });
});

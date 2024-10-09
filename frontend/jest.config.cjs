// jest.config.cjs
module.exports = {
  preset: '@vue/vue3-jest',
  testEnvironment: 'jsdom',
  transform: {
    '^.+\\.vue$': '@vue/vue3-jest',
    '^.+\\.js$': 'babel-jest',
  },
  moduleFileExtensions: ['js', 'json', 'vue'],
  testMatch: ['**/__tests__/**/*.spec.(js|jsx|ts|tsx|vue)'],
};
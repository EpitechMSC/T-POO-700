<template>
  <div>
    <form @submit.prevent="uploadFile">
      <input type="file" @change="handleFileChange" />
      <button type="submit">Upload File</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      selectedFile: null,
    };
  },
  methods: {
    handleFileChange(event) {
      this.selectedFile = event.target.files[0];
    },
    async uploadFile() {
      if (!this.selectedFile) {
        alert('Please select a file');
        return;
      }

      const formData = new FormData();
      formData.append('file', this.selectedFile);
      formData.append('contrat_id', 1); // Include contrat_id

      try {
        const response = await axios.post('/contrats/upload', formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        });
        console.log(response.data);
        alert('File uploaded successfully');
      } catch (error) {
        console.error('Error uploading file', error);
        alert('File upload failed');
      }
    },
  },
};
</script>

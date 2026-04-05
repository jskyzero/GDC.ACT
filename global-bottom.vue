<template>
  <footer 
    v-if="$nav.currentPage !== 1" 
    class="absolute bottom-4 right-4 px-2 py-1 bg-gray-100/50 backdrop-blur-md rounded-md text-[10px] text-gray-500 border border-gray-200/50"
  >
    {{ $nav.currentPage }} / {{ $nav.total }}
  </footer>
</template>
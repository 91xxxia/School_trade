<template>
    <div class="main-container">
        <div class="main-content">
            <slot></slot>
        </div>
    </div>
</template>

<script>
    export default {
        name: "PageBody"
    }
</script>

<style scoped>
    .main-container{
        padding-top: 64px; /* Match header height */
        min-height: 100vh;
        background-color: var(--color-bg-primary);
    }
    .main-content{
        width: 100%;
        /* max-width: 1200px;  Let individual pages control their container width via .app-container */
        margin: 0 auto;
    }
</style>
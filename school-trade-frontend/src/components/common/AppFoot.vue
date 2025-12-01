<template>
    <div class="foot-container">
        <div class="author">© 2025 校园二手交易平台 · Designed by 哈基米队</div>
    </div>
</template>

<script>
    export default {
        name: "Foot"
    }
</script>

<style scoped>
    .foot-container {
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 80px;
        margin-top: 40px;
        background-color: var(--color-bg-secondary);
    }

    .author {
        color: var(--color-text-secondary);
        font-size: 13px;
        font-weight: 400;
    }
</style>

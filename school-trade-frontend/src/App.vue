<template>
    <div id="app">
        <router-view></router-view>
    </div>
</template>
<style>
    html, body, #app{
        overflow: visible;
        background-color: var(--color-bg-primary);
        font-family: var(--font-family-base);
        color: var(--color-text-primary);
    }
</style>
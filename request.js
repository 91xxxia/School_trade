import axios from 'axios';

// 动态设置 baseURL
const baseURL = process.env.NODE_ENV === 'production'
    ? 'http://47.114.105.81/api'
    : '/api'; // 开发环境走代理

const service = axios.create({
    baseURL: baseURL,
    timeout: 5000
});

service.interceptors.request.use(
    config => {
        return config;
    },
    error => {
        console.log(error);
        return Promise.reject();
    }
);

service.interceptors.response.use(
    response => {
        if (response.status === 200) {
            return response.data;
        } else {
            Promise.reject();
        }
    },
    error => {
        console.log(error);
        return Promise.reject();
    }
);

export default service;

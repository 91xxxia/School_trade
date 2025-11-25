import axios from 'axios';

const service = axios.create({
    timeout: 5000,
    baseURL: process.env.VUE_APP_BASE_API || '/api', // 使用环境变量或默认值
    withCredentials:  true
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

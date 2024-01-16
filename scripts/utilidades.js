function redirect(url, params) {
    if (params) {
        for (let i = 0; i < params.length; i++) {
            localStorage.setItem(params[i][0], params[i][1]);
        }
    }
    location = url;
}
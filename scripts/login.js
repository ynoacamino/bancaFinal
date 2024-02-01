function login(type) {
    fetch2(["user", "password"], [`type=${type}`], "login.pl", function(response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            createStatusElements(errors, "form");
        } else {
            window.location = `./index_${type}s.html`;    
        }
    })
}
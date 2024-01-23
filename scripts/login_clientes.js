function login() {
    fetch2(["user", "password"], ["type=cliente"], "login.pl", function(response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            createStatusElements(errors, "form");
        } else {
            window.location = "./index_clientes.html";    
        }
    })
}
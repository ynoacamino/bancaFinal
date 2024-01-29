function createClient() {
    fetch2(["dni", "name", "plastname", "mlastname", "bdate"], [], "registro_clientes.pl", function(response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            // TODO: update these when the  v   htmls are done
            createStatusElements(errors, "form");
        } else {
            alert("Cliente creado correctamente");
            window.location = "./index_operarios.html";    
        }
    });
}
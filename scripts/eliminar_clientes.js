function removeClient() {
    fetch2(["dni"], [], "eliminar_clientes.pl", function(response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            // TODO: update these when the  v   htmls are done
            createStatusElements(errors, "form");
        } else {
            alert("Cliente eliminado correctamente");
            window.location = "./index_operarios.html";    
        }
    });
}
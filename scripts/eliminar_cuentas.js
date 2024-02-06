function removeAccount() {
    fetch2(["dni"], [], "eliminar_cuentas.pl", function(response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            // TODO: update these when the  v   htmls are done
            createStatusElements(errors, "form");
        } else {
            alert("Cuenta eliminada correctamente");
            window.location = "./index_operarios.html";    
        }
    });
}
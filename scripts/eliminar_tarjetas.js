function removeCard() {
    fetch2(["number"], [], "eliminar_tarjetas.pl", function(response) {
        const errors = response.getElementsByTagName("error");
        if (errors.length != 0) {
            // TODO: update these when the  v   htmls are done
            createStatusElements(errors, "form");
        } else {
            alert("Tarjeta eliminada correctamente");
            window.location = "./index_operarios.html";    
        }
    });
}
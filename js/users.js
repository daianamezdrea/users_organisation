function myFunction() {
    // Declare variables
    var input, filter, table, tr, td, i, txtValue;
    input = document.getElementById("myInput");
    filter = input.value.toUpperCase();
    table = document.getElementById("users_table");
    tr = table.querySelectorAll("tr[data-toggle='collapse']");
    td = table.getElementsByTagName("td");

    // Loop through all table rows, and hide those who don't match the search query
    for (i = 0; i < tr.length; i++) {
        var found = false;
        for (j = 1; j < td.length; j++) {
            td1 = tr[i].getElementsByTagName("td")[j];
            if (td1) {
                txtValue = td1.textContent || td1.innerText;
                found |= txtValue.toUpperCase().indexOf(filter) > -1;
            }
        }
        if (found) {
            tr[i].style.display = "";
        } else {
            tr[i].style.display = "none";
        }
    }
}
function initialize() {      

            // Valores inicias de filtragem
            var normal = 1;  // - Default
            var excecao = 0;
            var simultanea = 0;

            var B2b = '0';
            var tipoOcorrencia ='2';
            var ativas = 1;  // - Default
            var inativas = 0;
            var finalizadas = 0;

            $("#chkNormal").click(function () {
                isCheck = $("#chkNormal").is(":checked");
                if (isCheck == true) {
                    normal = 1;
                    $("#chkNormal").val(normal);

                } else {
                    normal = 0;
                    $("#chkNormal").val(normal);
                }
            });

            $("#chkSimultanea").click(function () {
                isCheck = $("#chkSimultanea").is(":checked");
                if (isCheck == true) {
                    simultanea = 1;
                    $("#chkSimultanea").val(simultanea);

                } else {
                    simultanea = 0;
                    $("#chkSimultanea").val(simultanea);
                }

            });

            $("#chkExcecao").click(function () {
                isCheck = $("#chkExcecao").is(":checked");
                if (isCheck == true) {
                    excecao = 1;
                    $("#chkExcecao").val(excecao);
                } else {
                    excecao = 0;
                    $("#chkExcecao").val(excecao);
                }
            });


            $("#Ativa").click(function () {
                ativas = 1;
            });

            $("#Inativa").click(function () {
                inativas = 1;
            });

            $("#Finalizada").click(function () {
                finalizadas = 1;
            });

            $("#Filtrar").click(function () {
                FiltrarOcorrencias()
            });

            function FiltrarOcorrencias() {
                console.log("TipoOcorrencia: " + tipoOcorrencia);
                console.log("B2b: " + B2b);
                console.log("Data Inicial: " + $('#dataInicial').val());
                console.log("Data Final: " + $('#dataFinal').val());
                alert("N: " + normal + " S: " + simultanea + " E: " + excecao + " A: " + ativas + " I: " + inativas + " F: " + finalizadas);
            }

            /* datepicker */
            $('#dataInicial')
                .datepicker({
                    format: "dd/mm/yyyy",
                    language: "pt-BR",
                    minViewMode: 0,
                    autoclose: 1,
                    todayHighlight: 1
                })
                .on('changeDate', function () {
                    var datanova = moment($('#dataInicial').val(), 'DD/MM/YYYY').add(30, 'days').format('DD/MM/YYYY');
                    $('#dataFinal').val(datanova);
                });


            $('#chkTrocaCanc').change(function () {
                stateCheck = $('#chkTrocaCanc').val();
                if (stateCheck == 'on') {
                    $('#chkTrocaCanc').val('off');
                    tipoOcorrencia = 2;
                } else {
                    $('#chkTrocaCanc').val('on');
                    tipoOcorrencia = 1;
                }
            });

            $('#chkB2b').change(function () {
                stateCheck = $('#chkB2b').val();
                if (stateCheck == 'on') {
                    $('#chkB2b').val('off');
                    B2b = 1;
                } else {
                    $('#chkB2b').val('on');
                    B2b = 0;
                }
            });

}
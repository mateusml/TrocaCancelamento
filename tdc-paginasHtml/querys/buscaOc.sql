--- BUSCAR POR ID DA OCORRENCIA
select
	oc.int_id_ocorrencia
	,oc.at_cadastro
	,oc.int_id_atendi_tipo
	,oc.str_nsu
	,oc.dat_atualizacao
	,oc.int_slip
	,oc.int_id_ocorr_motivo
	,oc.int_id_emb_estado
	,oc.str_rem_banco
	,oc.str_rem_titular
	,oc.str_rem_agencia
	,oc.str_rem_cpf_cnpj
	,oc.str_rem_conta
	,isnull(oc.str_rem_valor,'0,00') as str_rem_valor
	,oc.str_rem_data
	,oc.str_nota_reenvio
	,oc.int_id_transp_reenvio
	,oc.dat_solicitacao
	,oc.str_ca
	,oc.dat_efetivacao
	,oc.str_rcv
	,oc.int_nota_entrada
	,oc.str_processo
	,oc.dat_finalizacao
	,oc.int_id_ocorr_status
	,oc.str_detalhes
	,oc.str_cliente
	,oc.int_id_ocorr_tipo
	,oc.int_id_ocorr_causador
	,oc.str_prod_selecionado
	,oc.str_prod_qtd_selecionado
	,oc.str_observacao
	,oc.dat_efetivacao_estorno
	,oc.int_novo_slip
	,oc.dat_novo_slip
	,oc.str_email_to
	,oc.dta_entrega
	,oc.str_email_cc
	,oc.mon_valor
	,oc.str_dias_coleta as int_dias_coleta
	,oc.int_prazo_coleta
	,oc.dat_solicitacao_coleta
	,oc.str_num_identificador
	,oc.str_cartao_novo
	,oc.int_id_ocorr_status_aux
	,oc.dt_envio_csc
	,oc.str_altera_ocorr
	,oc.str_email_to
	,case
		when oc.int_id_ocorr_status_aux = 1 																								  then 1  	-- fase novo
		when oc.int_id_ocorr_status_aux = 2 																								  then 2  	-- fase solicitação cd
		when oc.int_id_ocorr_status_aux = 3 	 and int_id_ocorr_status = 3 																  then 2  	-- fase de nova coleta (desbloqueia passo operacional em caso de status principal e auxiliar serem iguais)
		when oc.int_id_ocorr_status_aux = 3   and dat_conf_retorno is null 																  then 3  	-- fase efetivação cd (a data de efetivação de retorno está vazia)
		when oc.int_id_ocorr_status_aux = 3   and int_id_ocorr_status = 20 																  then 3  	-- fase de nova coleta
		when oc.int_id_ocorr_status_aux = 3   and dat_conf_retorno is not null 															  then 10 	-- fase efetivação cd (vai para a avaliação de retorno)
		when oc.int_id_ocorr_status_aux = 3 	 and int_id_ocorr_status = 25 																  then 4  	-- fase solicitação nova coleta (chama a solicitação da coleta)
		when oc.int_id_ocorr_status_aux = 8 																								  then 4  	-- fase solicitação coleta (chama a solicitação da coleta)
		when oc.int_id_ocorr_status_aux = 9 																								  then 5  	-- fase confirmação retorno (confirmação do retorno)
		when oc.int_id_ocorr_status_aux = 10  and int_id_ocorr_status = 10 																  then 5 		-- fase avaliação de retorno (desbloqueia passo operacional em caso de status principal e auxiliar serem iguais)
		when oc.int_id_ocorr_status_aux = 10  and bit_aval_retorno = 1 and int_id_ocorr_tipo = 1 										  then 8  	-- fase avaliação de retorno
		when oc.int_id_ocorr_status_aux = 10  and bit_aval_retorno = 0 																	  then 6  	-- fase avaliação de retorno
		when oc.int_id_ocorr_status_aux = 10  and bit_aval_retorno = 1 and int_id_ocorr_tipo = 2 										  then 9  	-- fase avaliação de retorno
		when oc.int_id_ocorr_status_aux = 11  and bit_aceita_troca = 1 and int_id_ocorr_tipo = 1 										  then 8  	-- fase contato com o cliente
		when oc.int_id_ocorr_status_aux = 11  and bit_aceita_troca = 0 																	  then 7  	-- fase contato com o cliente
		when oc.int_id_ocorr_status_aux = 11  and bit_aceita_troca = 1 and int_id_ocorr_tipo = 2 										  then 9  	-- fase contato com o cliente
		when oc.int_id_ocorr_status_aux = 12  																							  then 8  	-- fase re-envio cliente
		when oc.int_id_ocorr_status_aux = 4 																								  then 9  	-- fase solicitação de reembolso
		when oc.int_id_ocorr_status_aux = 5 																								  then 10 	-- fase reembolso efetivado
		when oc.int_id_ocorr_status_aux 		 in (6, 12) and int_id_ocorr_status not in (5, 18)  										  then 11 	-- fase finalizado
		when oc.int_id_ocorr_status_aux = 12  and int_id_ocorr_status = 18 and isnull(int_novo_slip,0) <> 0  and dat_novo_slip is not null then 11 	-- fase finalizado
		-------------------------------------------------------------------------------------
		when oc.int_id_ocorr_status_aux = 15  and str_posicao_cliente = 's' 																  then 8  	-- fase finalizado
		when oc.int_id_ocorr_status_aux = 20 																							  then 3  	-- fase efetivação cd (a data de efetivação de retorno está vazia)
		when oc.int_id_ocorr_status_aux = 22 																							  then 7  	-- controle de produto
	else 
		0
	end as fase
	--##############################################################################################
	,oc.int_id_transp
	,oc.dat_conf_retorno
	case
		when 
			dat_limite is null then dateadd(day, int_prazo_coleta, dat_cadastro)
		else 
			dat_limite
	end as dat_limite
	,oc.dat_aval_retorno,
	isnull(bit_aval_retorno,0) as bit_aval_retorno
	,oc.str_obs_aval_retorno
	,oc.dat_contato_cli
	isnull(oc.bit_aceita_troca,0) as bit_aceita_troca
	,oc.str_obs_contato_cli
	,oc.dat_re_envio
	datediff(day, getdate(), dat_limite) as dia_limite
	,oc.str_status_ocorrencia
	,oc.str_motivo_altera_valor
	,oc.str_confirma_ocorr
	,oc.str_usu_confirma
	,oc.str_objeto
	,oc.str_confirma_retorno
	,oc.dat_resolucao
	,oc.str_resolucao
	,oc.str_novacoleta
	,oc.str_novacoleta_obs
	,oc.str_retorno_justificativa
	,oc.str_retorno_produto
	,oc.str_retorno_nota
	,oc.str_contato_cliente
	,oc.str_rec_ok
	,oc.str_posicao_cliente
	,oc.str_codseg_novo
	,oc.str_validade_novo
	,oc.str_mooc.tivo_prazo
	,oc.str_motivo_altera_valor_cancel
	,oc.str_forma_envio
	,oc.int_nf_trans
	,oc.str_cd
	,c.vendedor
	,oc.usr_logupdate
	,oc.bitmsgerro
	,oc.intPedido
	,mladm.intIdMlAdmin
	,oc.bitXMLEnviado
	,oc.flag_correios_coleta
	,oc.TipoOperacao
	,c.FILIALENTREGA
	,oc.intfilialocorrencia
	,null as oc.IntCartaoPresenteado
	,oc.bitPostagemCorreios
	,oc.bitProdutoEmDevolucao
	,oc.bitProdutoRecusado
	,oc.bitProdutoDeixadoNaLoja
	,oc.bitPresenteado
	,oc.bitRoteiroT_AcertoNF
	,oc.bitSimultanea
	,oc.bitColetaCorreios
	,oc.bitColetaComun
	,oc.bitNaoHaveraColeta
	,oc.bitInsucessoEntrega
	,oc.bitColetaPostagem

	,case when ISNULL(nvop.bitColetaNaLoja, 0) 			= 0  then 'Não' else 'Sim' 	end as ClienteIraRetirarNaLoja
	,case when oc.int_id_atendi_tipo					= 18 then 'Sim' else 'Não' 	end as ColetaSolicitadaNaLoja

	from
		ctrl_prod_ocorrencia 		oc (nolock)
	inner join
		dbmagazine_xp..contratos 	c (nolock)
		on 	oc.int_slip = c.nrcontrato and c.ninternet = oc.intPedido
	----------- Faz vínculo com a tabela "MAG_T_INTEGRACAO_MLADMIN_ADMSITE" p/ trazer o ID do Cancelamento/Troca MLADMIM -
	left join
		MAG_T_INTEGRACAO_MLADMIN_ADMSITE mladm (NOLOCK)
		on oc.int_id_ocorrencia = MAX(mladm.intIdOcorrencia)
	----------------------------------------------------------------------------------------------------------------------
	----------- Faz vínculo com a tabela "CTRL_PROD_NOVO" p/ trazer o bitColetaNaLoja -
	left join
	CTRL_PROD_NOVO nvop (NOLOCK)
		on oc.int_id_ocorrencia = nvop.int_id_ocorrencia
	----------------------------------------------------------------------------------------------------------------------
	where
		oc.int_id_ocorr_tipo = tipoOcorrencia;
--- BUSCAR POR ID DA OCORRENCIA		
--- BUSCAR POR ID PERIODO DE DATAS DE ABERTURA
		oc.dat_cadastro between dataInicial and dataFinal;
--- BUSCAR POR PERIODO DE DATAS DE ABERTURA
--- BUSCAR POR SubTipo no periodo
		oc.TipoOperacao = tipoOperacao   -- Normais, Simultâneas e Exceções
		and
		oc.dat_cadastro between dataInicial and dataFinal;
--- BUSCAR POR SubTipo
--- BUSCAR POR Ocorrencias Ativas no periodo
		Upper(oc.str_status_ocorrencia) = 'A'
		and
		oc.dat_cadastro between dataInicial and dataFinal;
--- BUSCAR POR Ocorrencias Ativas no periodo
--- BUSCAR POR Ocorrencias InAtivas no periodo
		Upper(oc.str_status_ocorrencia) = 'I'
		and
		oc.dat_cadastro between dataInicial and dataFinal;
--- BUSCAR POR Ocorrencias InAtivas no periodo
--- BUSCAR POR Ocorrencias Finalizadas no Periodo
		Upper(oc.int_id_ocorr_status) = 13
		and 
		oc.dat_finalizacao is not null
		and
		oc.dat_cadastro between dataInicial and dataFinal;
--- BUSCAR POR Ocorrencias Finalizadas no Periodo
--- BUSCAR POR Ocorrencias B2B no Periodo
		C.VENDEDOR in ( 3445, 4669 )         -- Inserir outros vendedores conforme forem aparecendo
		and
		oc.dat_cadastro between dataInicial and dataFinal;
   
	
	
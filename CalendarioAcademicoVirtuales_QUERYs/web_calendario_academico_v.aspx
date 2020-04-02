<%@ Page Language="C#" AutoEventWireup="true" CodeFile="web_calendario_academico_v.aspx.cs" Inherits="privado_web_calendario_academico_v" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../estilos.css" rel="stylesheet" />
    <script src="../assets/js/jquery-3.3.1.js"></script>
    <style>
        tr.selected {
            background-color: #1673c3 !important;
            color: #fff;
        }

        #gridMaterias tr:hover {
            cursor: pointer;
        }

    </style>
    <script>
        var materias = [];
        $(document).ready(function () {

            if ($("#gridBloques").length) {
                $("#lbMatAsig").show();
            } else {
                $("#lbMatAsig").hide();

            }

            $("#gridMaterias tbody tr").click(function () {

                $(this).toggleClass('selected');
                ToggleMat(materias, $($(this).find("td")[0]).text().trim())

            });
        });

        function ToggleMat(Amaterias, mat) {
            var i = Amaterias.indexOf(mat);

            if (i >= 0) {

                Amaterias.splice(i, 1)

            } else {

                Amaterias.push(mat)
            }
        }

        function Save() {
            if (confirm("Se agregara " + materias.length + " materias al calendario.")) {
                var codmats = "MATERIAS";
                for (var i = 0; i < materias.length; i++) {
                    codmats = codmats + "%" + materias[i];
                }
                $("#hfMaterias").val(codmats);
                return true;
            } else {
                return false;
            }

        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div style="background-color: gainsboro">
                <b>CALENDARIO ACADEMICO VIRTUALES</b>
            </div>
            <br />
            <br />
            <fieldset>
                <legend>Opciones</legend>
                <asp:RadioButtonList ID="rdOpctions" runat="server" AutoPostBack="true" Font-Bold="true" OnTextChanged="rdOpctions_TextChanged">
                    <asp:ListItem Value="CONSULTAR FECHAS DE BLOQUES" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="INSERCION A BLOQUES"></asp:ListItem>
                </asp:RadioButtonList>
            </fieldset>
            <table>
                <tr>
                    <td>Carrera:</td>
                    <td>
                        <table>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlCarrera" runat="server" DataSourceID="sdsCar" DataTextField="car_nombre" DataValueField="car_codigo" AutoPostBack="true" OnTextChanged="ddlCarrera_TextChanged"></asp:DropDownList>
                                    <asp:SqlDataSource ID="sdsCar" runat="server" ConnectionString="<%$ ConnectionStrings:raConnectionString %>"
                                        SelectCommand="select car_codigo,car_nombre from ra_car_carreras 
                                                where car_codtde = 1 and  car_estado = 'A' and car_nombre like '%NO PRESENCIAL%'"></asp:SqlDataSource>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>Plan:</td>
                    <td>
                        <asp:DropDownList ID="ddlPlan" runat="server" DataSourceID="sdsPlan" DataTextField="pla_nombre" DataValueField="pla_codigo" AutoPostBack="true" OnTextChanged="ddlPlan_TextChanged"></asp:DropDownList>
                        <asp:SqlDataSource ID="sdsPlan" runat="server" ConnectionString="<%$ ConnectionStrings:raConnectionString %>"
                            SelectCommand="select 0 pla_codigo, 'Seleccione' pla_nombre union
                                            select pla_codigo,pla_nombre from ra_pla_planes where pla_codcar = @codcar and pla_estado = 'A'">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="ddlCarrera" Name="codcar" PropertyName="SelectedValue" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td>Evaluacion:</td>
                    <td>
                        <asp:DropDownList ID="ddlEvaluacion" runat="server" AutoPostBack="true" OnTextChanged="ddlEvaluacion_TextChanged">
                            <asp:ListItem Value="0" Text="Seleccione"></asp:ListItem>
                            <asp:ListItem Value="1" Text="1"></asp:ListItem>
                            <asp:ListItem Value="2" Text="2"></asp:ListItem>
                            <asp:ListItem Value="3" Text="3"></asp:ListItem>
                            <asp:ListItem Value="4" Text="4"></asp:ListItem>
                            <asp:ListItem Value="5" Text="5"></asp:ListItem>
                            <asp:ListItem Value="6" Text="6"></asp:ListItem>
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbBF" Text="Bloque de fecha:" runat="server" Visible="false" /> </td>
                    <td>
                        <asp:DropDownList ID="ddl_bloque" runat="server" AutoPostBack="True" DataSourceID="sdsBloq" DataTextField="nombre" DataValueField="codigo" OnTextChanged="ddl_bloque_TextChanged" Visible="false">

                        </asp:DropDownList>
                        <asp:SqlDataSource ID="sdsBloq" runat="server" ConnectionString="<%$ ConnectionStrings:raConnectionString %>" 
                            SelectCommand="select distinct caav_bloque codigo, concat(caav_bloque,'  - [ ',convert(nvarchar(10),caav_fecha_limite,103),' ]') nombre
                                                from web_caav_calendario_acad_virtual where caav_codpla = @codpla and caav_evaluacion = @eva
                                                union
                                                select codigo,nombre from (
                                                select 1 codigo , '1' nombre
                                                union select 2 , '2' union select 3 , '3' union select 4 , '4'
                                                union select 5 , '5' union select 6 , '6' union select 7 , '7' 
                                                union select 8 , '8' union select 0 , ' Seleccione')t 
                                                where codigo not in (select caav_bloque 
                                                from web_caav_calendario_acad_virtual 
                                                where caav_codpla = @codpla and caav_evaluacion = @eva)
                                                order by caav_bloque">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="ddlPlan" Name="codpla" PropertyName="SelectedValue" />
                                <asp:ControlParameter ControlID="ddlEvaluacion" Name="eva" PropertyName="SelectedValue" />

                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table>
                            <tr>
                                <td>
                                    <asp:GridView runat="server" ID="gridMaterias" DataSourceID="sdsMat" AutoGenerateColumns="False" DataKeyNames="mat_codigo" Visible="false" ShowHeader="false" CellPadding="3">
                                        <Columns>
                                            <asp:BoundField DataField="mat_codigo" HeaderText="CODMAT" ReadOnly="True" SortExpression="mat_codigo" />
                                            <asp:BoundField DataField="mat_nombre" HeaderText="MATERIA" ReadOnly="True" SortExpression="mat_nombre" />
                                        </Columns>
                                    </asp:GridView>
                                    <%--<td>Materia:</td>    --%>
                                    <%--<td><asp:DropDownList ID="ddlMateria" runat="server" DataSourceID="sdsMat" DataTextField="mat_nombre" DataValueField="mat_codigo" AutoPostBack="true"></asp:DropDownList>--%>
                                    <asp:SqlDataSource ID="sdsMat" runat="server" ConnectionString="<%$ ConnectionStrings:raConnectionString %>"
                                        SelectCommand="select distinct mat_codigo ,rtrim(mat_nombre) mat_nombre from ra_mat_materias 
	                                            left join web_caav_calendario_acad_virtual on caav_codmat = mat_codigo
	                                            inner join ra_plm_planes_materias on plm_codmat = mat_codigo
	                                            inner join ra_pla_planes on pla_codigo = plm_codpla
	                                            where pla_codigo = @codpla and mat_electiva = 'N' and mat_tipo &lt;&gt; 'S' 
									            and mat_codigo not in (select caav_codmat from web_caav_calendario_acad_virtual
							                    where caav_codmat = mat_codigo 
							                    and caav_codpla = pla_codigo 
							                    and caav_evaluacion = @eva)
	                                            order by mat_nombre">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlPlan" Name="codpla" PropertyName="SelectedValue" />
                                            <asp:ControlParameter ControlID="ddlEvaluacion" Name="eva" PropertyName="SelectedValue" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>

                                </td>
                                <td style="vertical-align: top; padding-left: 20px">
                                    <br />
                                    <b><asp:Label ID="lbMatAsig" Text="MATERIAS ASIGNADAS" runat="server" /></b>
                                  <br />
                                    <br />
                                     <asp:GridView ID="gridBloques" runat="server" AutoGenerateColumns="False" DataSourceID="sdsBloqus" DataKeyNames="caav_codigo" CellPadding="4">
                                        <Columns>
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="deletebtn" runat="server" CommandName="Delete"
                                                        Text="Delete" OnClientClick="return confirm('¿Desea quitar la materia?');"
                                                        ImageUrl="~/imagenes/Eliminar_no_efect.gif" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="mat_codigo" HeaderText="CODMAT" ReadOnly="True" SortExpression="mat_codigo" />
                                            <asp:BoundField DataField="mat_nombre" HeaderText="MATERIA" ReadOnly="True" SortExpression="mat_nombre" />
                                            <asp:BoundField DataField="caav_evaluacion" HeaderText="EVALUACION" ReadOnly="True" SortExpression="caav_evaluacion" />
                                            <asp:BoundField DataField="caav_bloque" HeaderText="BLOQUE FECHA" ReadOnly="True" SortExpression="caav_bloque" />
                                        </Columns>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="sdsBloqus" runat="server" ConnectionString="<%$ ConnectionStrings:raConnectionString %>" 
                                        SelectCommand="sp_calendario_academico_virtual" SelectCommandType="StoredProcedure" 
                                        DeleteCommand="delete web_caav_calendario_acad_virtual where caav_codigo = @caav_codigo" DeleteCommandType="Text" OnDeleted="sdsBloqus_Deleted">
                                        <SelectParameters>
                                            <asp:Parameter DefaultValue="3" Name="opcion" Type="Int32" />
                                            <asp:Parameter DefaultValue="0" Name="codmat" Type="String" />
                                            <asp:ControlParameter ControlID="ddlPlan" DefaultValue="" Name="codpla" PropertyName="SelectedValue" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlEvaluacion" Name="evaluacion" PropertyName="SelectedValue" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddl_bloque" Name="bloque_fecha" PropertyName="SelectedValue" Type="Int32" />
                                            <asp:Parameter DefaultValue="0" Name="fecha_li" Type="String" />
                                            <asp:Parameter DefaultValue="0" Name="coduser" Type="Int32" />
                                        </SelectParameters>
                                        <DeleteParameters>
                                            <asp:Parameter Name="caav_codigo" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                        </table>
                    </td>

                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnIngresar" runat="server" Text="INGRESAR" OnClick="btnIngresar_Click" OnClientClick="return Save()" Visible="false" />
                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td class="auto-style1">
                        <table runat="server" id="tblLimites" visible="false">
                            <tr>
                                <td colspan="2"><b>FECHAS LIMITES
                                    <asp:Label ID="lbCarrera" Text="" runat="server" /></b></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="gridFechas" runat="server" AutoGenerateColumns="False" DataSourceID="sdsDate" CellPadding="4" EmptyDataText="No existen registros ingresados para esta evaluación" DataKeyNames="codpla,evaluacion,bloque_fecha">
                                        <Columns>
                                          <asp:CommandField ButtonType="Image" CancelImageUrl="~/imagenes/Cancelar_no_efect.gif"
                                                EditImageUrl="~/imagenes/Editar_no_efect.gif"
                                                ShowEditButton="True" UpdateImageUrl="~/imagenes/save_ico_sin_sombra.gif">                                               
                                            </asp:CommandField>
                                            <asp:BoundField DataField="evaluacion" HeaderText="EVALUACION" SortExpression="evaluacion" ReadOnly="true" />
                                            <asp:BoundField DataField="bloque_fecha" HeaderText="BLOQUE FECHA" ReadOnly="true"/>
                                            <asp:BoundField DataField="fecha_li" HeaderText="FECHA" SortExpression="fecha_li"/>
                                        </Columns>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="sdsDate" runat="server" ConnectionString="<%$ ConnectionStrings:raConnectionString %>" SelectCommand="sp_calendario_academico_virtual" SelectCommandType="StoredProcedure" UpdateCommand="sp_calendario_academico_virtual" UpdateCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter DefaultValue="2" Name="opcion" Type="Int32" />
                                            <asp:Parameter DefaultValue="0" Name="codmat" Type="String" />
                                            <asp:ControlParameter ControlID="ddlPlan" Name="codpla" PropertyName="SelectedValue" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlEvaluacion" Name="evaluacion" PropertyName="SelectedValue" Type="Int32" />
                                            <asp:Parameter Name="bloque_fecha" Type="Int32" DefaultValue="0" />
                                            <asp:Parameter DefaultValue="0" Name="fecha_li" Type="String" />
                                            <asp:Parameter DefaultValue="0" Name="coduser" Type="Int32" />
                                        </SelectParameters>
                                        <UpdateParameters>
                                            <asp:Parameter DefaultValue="4" Name="opcion" Type="Int32" />
                                            <asp:Parameter DefaultValue="0" Name="codmat" Type="String" />
                                            <asp:Parameter Name="codpla" Type="Int32" />
                                            <asp:Parameter Name="evaluacion" Type="Int32" />
                                            <asp:Parameter Name="bloque_fecha" Type="Int32" />
                                            <asp:Parameter Name="fecha_li" Type="String" />
                                            <asp:Parameter DefaultValue="0" Name="coduser" Type="Int32" />
                                        </UpdateParameters>
                                    </asp:SqlDataSource>
                                </td>
                                <td style="vertical-align: top; padding-left: 200px">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

            <br />
            <br />
            <asp:HiddenField ID="hfMaterias" runat="server" />

        </div>
    </form>
    <script>
        var myJson = {
            Person: [{ codper: "N1", name: "NAME ONE" },
                     { codper: "N2", name: "NAME TWO" },
                     { codper: "N3", name: "NAME THREE" },
                     { codper: "N4", name: "NAME FOUR" }
            ]
        }

        function SearchData(data, cod) {
            let resp = -1;
            for (let i in data) {
                if (data[i].codper == cod) {
                    resp = i;
                    break
                }
            }
            return resp;
        }

        function TogglePerson(_codper, _name) {
            var indx = SearchData(myJson.Person, _codper);
            if (indx >= 0) {
                myJson.Person.splice([indx],1);
            } else {
                myJson.Person.push({ codper: _codper, name: _name })
            }
        }


    </script>
</body>
</html>

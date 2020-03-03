using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class privado_web_calendario_academico_v : System.Web.UI.Page
{
    crud_general crd = new crud_general();
    protected void Page_Load(object sender, EventArgs e)
    {
        sdsMat.DataBind();
        gridMaterias.DataBind();

    }

    private void InsertCal(string codmat)
    {
        string resp = crd.insert_query(new string[] { "opcion", "codmat", "codpla","evaluacion","bloque_fecha","fecha_li", "coduser" },
                         new string[] { "1", codmat, ddlPlan.SelectedValue.Trim(),ddlEvaluacion.SelectedValue.Trim(),ddl_bloque.SelectedValue, "", Session["Codigousuario"].ToString()},
                         "sp_calendario_academico_virtual");
        //Response.Write(resp);
    }



    protected void btnIngresar_Click(object sender, EventArgs e)
    {
        string[] matCodigos;

        if (hfMaterias.Value != "")
        {
            //InsertCal();
            matCodigos = hfMaterias.Value.Split('%');
            for (int i = 1; i < matCodigos.Length; i++)
            {
               InsertCal(matCodigos[i]);
            }

            ClientScript.RegisterStartupScript(GetType(), "", "alert('Registros ingresados correctamente.')",true);

            sdsMat.DataBind();
            sdsBloqus.DataBind();
            gridMaterias.DataBind();
            gridBloques.DataBind();


        }
        else
        {
            ClientScript.RegisterStartupScript(GetType(), "", "alert('Seleccione materias!!!')", true);
        }
    }

    protected void ddlEvaluacion_TextChanged(object sender, EventArgs e)
    {
        //if (rdOpctions.SelectedValue == "CONSULTA")
        //{
        //    tblLimites.Visible = true;
        //    ddl_bloque.Visible = false;
        //    lbBF.Visible = false;
        //}

    }

    private void ClearControls(bool visible)
    {
            ddlPlan.SelectedValue = "0";
            ddlEvaluacion.SelectedValue = "0";
            gridMaterias.Visible = false;
            btnIngresar.Visible = visible;
            tblLimites.Visible = false;
            ddl_bloque.Visible = visible;
            lbBF.Visible = visible;
    }

    protected void rdOpctions_TextChanged(object sender, EventArgs e)
    {
        if(rdOpctions.SelectedIndex == 0)
        {
            ClearControls(false);
        }
        else
        {
            ClearControls(true);
        }
    }

    protected void ddlCarrera_TextChanged(object sender, EventArgs e)
    {
        ddlEvaluacion.SelectedValue = "0";
        gridMaterias.Visible = false;
        lbCarrera.Text = ddlCarrera.SelectedItem.Text;
        tblLimites.Visible = false;
        ddl_bloque.SelectedValue = "0";
        ddlPlan.SelectedValue = "0";

    }


    protected void ddlPlan_TextChanged(object sender, EventArgs e)
    {
        if(rdOpctions.SelectedIndex == 0)
        {
            tblLimites.Visible = true;
            ddl_bloque.Visible = false;
            lbBF.Visible = false;
        }
    }

    protected void ddl_bloque_TextChanged(object sender, EventArgs e)
    {
        if (ddl_bloque.SelectedValue == "0" || ddlEvaluacion.SelectedValue == "0" || rdOpctions.SelectedIndex == 0)
        {
            gridMaterias.Visible = false;

        }
        else
        {
            gridMaterias.Visible = true;
        }
    }

    protected void sdsBloqus_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        sdsMat.DataBind();
        gridMaterias.DataBind();
    }
}
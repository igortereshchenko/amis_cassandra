namespace _2017_12_23
{
    partial class AddBuyer
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.textBoxBuyerID = new System.Windows.Forms.TextBox();
            this.textBoxBuyerName = new System.Windows.Forms.TextBox();
            this.textBoxBuyerBalance = new System.Windows.Forms.TextBox();
            this.labelBuyerID = new System.Windows.Forms.Label();
            this.labelBuyerName = new System.Windows.Forms.Label();
            this.labelBuyerBalance = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.buttonAddBuyer = new System.Windows.Forms.Button();
            this.panel3 = new System.Windows.Forms.Panel();
            this.panel4 = new System.Windows.Forms.Panel();
            this.buttonCalculateBuyerId = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            this.panel4.SuspendLayout();
            this.SuspendLayout();
            // 
            // textBoxBuyerID
            // 
            this.textBoxBuyerID.Location = new System.Drawing.Point(91, 5);
            this.textBoxBuyerID.Name = "textBoxBuyerID";
            this.textBoxBuyerID.Size = new System.Drawing.Size(169, 20);
            this.textBoxBuyerID.TabIndex = 0;
            // 
            // textBoxBuyerName
            // 
            this.textBoxBuyerName.Location = new System.Drawing.Point(91, 34);
            this.textBoxBuyerName.Name = "textBoxBuyerName";
            this.textBoxBuyerName.Size = new System.Drawing.Size(245, 20);
            this.textBoxBuyerName.TabIndex = 1;
            // 
            // textBoxBuyerBalance
            // 
            this.textBoxBuyerBalance.Location = new System.Drawing.Point(91, 64);
            this.textBoxBuyerBalance.Name = "textBoxBuyerBalance";
            this.textBoxBuyerBalance.Size = new System.Drawing.Size(245, 20);
            this.textBoxBuyerBalance.TabIndex = 2;
            // 
            // labelBuyerID
            // 
            this.labelBuyerID.AutoSize = true;
            this.labelBuyerID.Location = new System.Drawing.Point(3, 8);
            this.labelBuyerID.Name = "labelBuyerID";
            this.labelBuyerID.Size = new System.Drawing.Size(51, 13);
            this.labelBuyerID.TabIndex = 3;
            this.labelBuyerID.Text = "Buyer ID:";
            // 
            // labelBuyerName
            // 
            this.labelBuyerName.AutoSize = true;
            this.labelBuyerName.Location = new System.Drawing.Point(3, 37);
            this.labelBuyerName.Name = "labelBuyerName";
            this.labelBuyerName.Size = new System.Drawing.Size(68, 13);
            this.labelBuyerName.TabIndex = 4;
            this.labelBuyerName.Text = "Buyer Name:";
            // 
            // labelBuyerBalance
            // 
            this.labelBuyerBalance.AutoSize = true;
            this.labelBuyerBalance.Location = new System.Drawing.Point(3, 67);
            this.labelBuyerBalance.Name = "labelBuyerBalance";
            this.labelBuyerBalance.Size = new System.Drawing.Size(79, 13);
            this.labelBuyerBalance.TabIndex = 5;
            this.labelBuyerBalance.Text = "Buyer Balance:";
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.buttonCalculateBuyerId);
            this.panel1.Controls.Add(this.textBoxBuyerID);
            this.panel1.Controls.Add(this.textBoxBuyerName);
            this.panel1.Controls.Add(this.textBoxBuyerBalance);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(345, 133);
            this.panel1.TabIndex = 6;
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.labelBuyerID);
            this.panel2.Controls.Add(this.labelBuyerName);
            this.panel2.Controls.Add(this.labelBuyerBalance);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Left;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.MinimumSize = new System.Drawing.Size(84, 109);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(84, 133);
            this.panel2.TabIndex = 7;
            // 
            // buttonAddBuyer
            // 
            this.buttonAddBuyer.Dock = System.Windows.Forms.DockStyle.Right;
            this.buttonAddBuyer.Location = new System.Drawing.Point(270, 0);
            this.buttonAddBuyer.Name = "buttonAddBuyer";
            this.buttonAddBuyer.Size = new System.Drawing.Size(75, 25);
            this.buttonAddBuyer.TabIndex = 8;
            this.buttonAddBuyer.TabStop = false;
            this.buttonAddBuyer.Text = "Add Buyer";
            this.buttonAddBuyer.UseVisualStyleBackColor = true;
            this.buttonAddBuyer.Click += new System.EventHandler(this.button1_Click);
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.buttonAddBuyer);
            this.panel3.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel3.Location = new System.Drawing.Point(0, 133);
            this.panel3.MinimumSize = new System.Drawing.Size(254, 25);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(345, 25);
            this.panel3.TabIndex = 9;
            // 
            // panel4
            // 
            this.panel4.Controls.Add(this.panel2);
            this.panel4.Controls.Add(this.panel1);
            this.panel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel4.Location = new System.Drawing.Point(0, 0);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(345, 133);
            this.panel4.TabIndex = 10;
            // 
            // buttonCalculateBuyerId
            // 
            this.buttonCalculateBuyerId.Location = new System.Drawing.Point(266, 3);
            this.buttonCalculateBuyerId.Name = "buttonCalculateBuyerId";
            this.buttonCalculateBuyerId.Size = new System.Drawing.Size(75, 25);
            this.buttonCalculateBuyerId.TabIndex = 9;
            this.buttonCalculateBuyerId.TabStop = false;
            this.buttonCalculateBuyerId.Text = "Calculate";
            this.buttonCalculateBuyerId.UseVisualStyleBackColor = true;
            this.buttonCalculateBuyerId.Click += new System.EventHandler(this.buttonCalculateBuyerId_Click);
            // 
            // AddBuyer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(345, 158);
            this.Controls.Add(this.panel4);
            this.Controls.Add(this.panel3);
            this.MinimumSize = new System.Drawing.Size(361, 196);
            this.Name = "AddBuyer";
            this.Text = "AddBuyer";
            this.Load += new System.EventHandler(this.AddBuyer_Load);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel4.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TextBox textBoxBuyerID;
        private System.Windows.Forms.TextBox textBoxBuyerName;
        private System.Windows.Forms.TextBox textBoxBuyerBalance;
        private System.Windows.Forms.Label labelBuyerID;
        private System.Windows.Forms.Label labelBuyerName;
        private System.Windows.Forms.Label labelBuyerBalance;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Button buttonAddBuyer;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.Button buttonCalculateBuyerId;
    }
}
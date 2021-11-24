<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Nilai Peserta</title>
    <link rel="shortcut icon" href="<?= base_url() ?>/assets/img/logo.png" />

    <!-- Custom fonts for this template-->
    <link href="<?= base_url('assets/'); ?>vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="<?= base_url('assets/'); ?>css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body class="bg-light">


    <!-- Outer Row -->
	<?php
	$no_p = $this->input->get('no_p');

	?>
	<div class="container-fluid">

	<!-- Page Heading -->
	<div class="text-center pt-3">
		<img src="<?= base_url() ?>/assets/img/logo.png" width="300px" />
		<h1 class="h4 text-gray-900 mb-4 font-weight-bold">Detail Nilai</h1>
	</div>
	<div class="card border-left-primary shadow mb-4">
		<div class="card-header py-2">
		</div>
		<div class="card-body">
			<div class="table-responsive table-wrapper-scroll-y my-custom-scrollbar">
				<table class="table table-bordered table-striped text-center" id="score" cellspacing="0">
					<thead>
						<tr>
							<th class="col-1">No</th>
							<th>Nama Kategori</th>
							<th>Nilai</th>
						</tr>
					</thead>
					<tbody>
						<?php
						$no = 1;
						$result = $this->db->query("call get_nilai_list_by_no_peserta('$no_p')");
						foreach ($result->result_array() as $row) {
						?>
						<tr>
							<td><?= $no ?></td>
							<td><?= $row['nama_kategori'] ?></td>
							<td><?= $row['total_nilai_kategori'] ?></td>
						</tr>
						<?php
							$no++;
							}
						?>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!-- card soal -->

	</div>

	<!-- /.container-fluid -->
	</div>
	<!-- End of Main Content -->
	<footer class="sticky-footer bg-white">
	<div class="container my-auto">
		<div class="copyright text-center my-auto">
			<span>Copyright &copy;Website 2021</span>
		</div>
	</div>
	</footer>

	</div>
	<!-- End of Content Wrapper -->

	</div>
	<!-- End of Page Wrapper -->

	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded" href="#page-top">
	<i class="fas fa-angle-up"></i>
	</a>



    <script src="<?= base_url('assets/'); ?>vendor/jquery/jquery.min.js"></script>
	<script src="<?= base_url('assets/'); ?>vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Core plugin JavaScript-->
	<script src="<?= base_url('assets/'); ?>vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for all pages-->
	<script src="<?= base_url('assets/'); ?>js/sb-admin-2.min.js"></script>
	<script src="<?= base_url('assets/'); ?>ckeditor/ckeditor.js"></script>

	<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
	<script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
	<script src="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css"></script>
	<script src="https://cdn.datatables.net/1.10.25/js/dataTables.bootstrap4.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.7.1/css/buttons.dataTables.min.css"></script>

	<script src="https://cdn.datatables.net/buttons/1.7.1/js/dataTables.buttons.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.html5.min.js"></script>
	<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.print.min.js"></script>
    <script type="">
$(document).ready(function() {
    $('#score').DataTable( {
        dom: 'Bfrtip',
        buttons: [
            'copy', 'csv', 'excel', 'pdf', 'print'
        ]
    } );
} );
</script>

</body>

</html>

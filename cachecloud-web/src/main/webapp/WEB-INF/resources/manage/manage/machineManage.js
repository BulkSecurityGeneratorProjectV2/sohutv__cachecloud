function removeMachine(id, ip) {
    var removeMachineBtn = document.getElementById(id);
    removeMachineBtn.disabled = true;
    $.get(
        '/manage/machine/checkMachineInstances.json',
        {
            ip: ip,
        },
        function (data) {
            var machineHasInstance = data.machineHasInstance;
            var alertMsg;
            if (machineHasInstance == true) {
                alertMsg = "该机器ip=" + ip + "还有运行中的Redis节点,确认要删除吗？";
            } else {
                alertMsg = "确认要删除ip=" + ip + "吗?";
            }
            if (confirm(alertMsg)) {
                location.href = "/manage/machine/delete?machineIp=" + ip;
            } else {
                removeMachineBtn.disabled = false;
            }
        }
    );
}

function saveOrUpdateMachine(machineId) {
    var ip = document.getElementById("ip" + machineId);
    var room = document.getElementById("machineRoom" + machineId);
    var mem = document.getElementById("mem" + machineId);
    var cpu = document.getElementById("cpu" + machineId);
    var disk = document.getElementById("disk" + machineId);
    var virtual = document.getElementById("virtual" + machineId);
    var disType = document.getElementById("disType" + machineId);
    var realIp = document.getElementById("realIp" + machineId);
    var machineType = document.getElementById("machineType" + machineId);
    var useType = document.getElementById("useType1" + machineId);
    var extraDesc = document.getElementById("extraDesc" + machineId);
    var collect = document.getElementById("collect" + machineId);
    var versionInfo = document.getElementById("versionInfo" + machineId);
    var k8sType = document.getElementById("k8sType" + machineId);
    var rack = document.getElementById("rack" + machineId);

    if (ip.value == "") {
        alert("IP不能为空!");
        ip.focus();
        return false;
    }
    if (room.value == "") {
        alert("机房不能为空!");
        room.focus();
        return false;
    }
    if (mem.value == "") {
        alert("内存不能为空!");
        mem.focus();
        return false;
    }
    if (cpu.value == "") {
        alert("CPU不能为空!");
        cpu.focus();
        return false;
    }
    if (disk.value == "") {
        alert("磁盘不能为空!");
        disk.focus();
        return false;
    }
    if (virtual.value == "") {
        alert("是否虚机为空!");
        virtual.focus();
        return false;
    }
    var addMachineBtn = document.getElementById("addMachineBtn" + machineId);
    addMachineBtn.disabled = true;

    $.post(
        '/manage/machine/addMultiple.json',
        {
            ip: ip.value,
            room: room.value,
            mem: mem.value,
            cpu: cpu.value,
            disk: disk.value,
            virtual: virtual.value,
            disType: disType.value,
            realIp: realIp.value,
            id: machineId,
            machineType: machineType.value,
            useType: useType.value,
            k8sType: k8sType.value,
            extraDesc: extraDesc.value,
            rack: rack.value,
            collect: collect.value,
            versionInfo: versionInfo.value
        },
        function (data) {
            if (data.result) {
                $("#machineInfo" + machineId).html("<div class='alert alert-error' ><button class='close' data-dismiss='alert'>×</button><strong>Success!</strong>更新成功，窗口会自动关闭</div>");
                var targetId = "#addMachineModal" + machineId;
                setTimeout("$('" + targetId + "').modal('hide');window.location.reload();", 1000);
            } else {
                addMachineBtn.disabled = false;
                $("#machineInfo" + machineId).html("<div class='alert alert-error' ><button class='close' data-dismiss='alert'>×</button><strong>Error!</strong>更新失败！</div>");
            }
        }
    );
}


function removeRoom(id, roomId) {
    var removeBtn = document.getElementById(id);
    removeBtn.disabled = true;
    var alertMsg = "确认要删除该机房吗?";
    console.log("roomid:"+roomId);
    if (confirm(alertMsg)) {
        location.href = "/manage/machine/room/delete?id=" + roomId;
    } else {
        removeBtn.disabled = false;
    }
}

function saveOrUpdateRoom(roomId) {
    var id = document.getElementById("roomId" + roomId);
    var name = document.getElementById("name" + roomId);
    var status = document.getElementById("status" + roomId);
    var desc = document.getElementById("desc" + roomId);
    var ipNetwork = document.getElementById("ipNetwork" + roomId);
    var operator = document.getElementById("operator" + roomId);


    if (name.value == "") {
        alert("机房名称不能为空!");
        ip.focus();
        return false;
    }
    var addRoomBtn = document.getElementById("addRoomBtn" + roomId);
    addRoomBtn.disabled = true;

    $.post(
        '/manage/machine/room/add.json',
        {
            id: id == null ? null : id.value,
            name: name.value,
            status: status.value,
            desc: desc.value,
            ipNetwork: ipNetwork.value,
            operator: operator.value,
        },
        function (data) {
            if (data.result) {
                $("#machineRoom" + roomId).html("<div class='alert alert-error' ><button class='close' data-dismiss='alert'>×</button><strong>Success!</strong>更新成功，窗口会自动关闭</div>");
                var targetId = "#addRoomModal" + roomId;
                setTimeout("$('" + targetId + "').modal('hide');window.location.reload();", 1000);
            } else {
                addRoomBtn.disabled = false;
                $("#machineRoom" + roomId).html("<div class='alert alert-error' ><button class='close' data-dismiss='alert'>×</button><strong>Error!</strong>更新失败！</div>");
            }
        }
    );
}
$( document ).ready(function() {

  $( "#calculate-bmi" ).click( function() {
    var patientHeight = ($( "#inputheight" ).val())/100; //convert cm to metres
    var patientWeight = $( "#inputweight" ).val();
    console.log(patientHeight + patientWeight);

    //build payload
    swaggerurl = "http://ec2-54-237-33-114.compute-1.amazonaws.com:8020/ec2/Centile/GetAllCentiles?AgeInYears="+patientAge+"&HeightInMetres="+patientHeight+"&Sex="+patientSex+"&WeightInKG="+patientWeight;

    //API call
    $.get(swaggerurl, function(data,status){
      console.log(status);
      console.log("heightcentile: "+ data.HeightStats.Centile, "weightcentile: "+data.WeightStats.Centile, "BMI: "+data.BMI, "BMIcentile: "+data.BMIStats.Centile);

      //enter results into table#results
      $("td#heightcentile").html(Math.round(data.HeightStats.Centile)+"th");
      $("td#weightcentile").html(Math.round(data.WeightStats.Centile)+"th");
      $("td#bmi").html(Math.round(data.BMI)+" kgm<sup>-2</sup>");
      $("td#bmicentile").html(Math.round(data.BMIStats.Centile)+"th");
      $("#results").slideDown("slow");
    });
  });

  $.ajax({
    url: "http://ec2-54-237-33-114.compute-1.amazonaws.com:8020/ec2/Centile/swagger/",

  });

});
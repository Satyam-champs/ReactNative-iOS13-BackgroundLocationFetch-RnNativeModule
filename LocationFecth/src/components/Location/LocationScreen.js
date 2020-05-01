import React, { useEffect } from 'react';
import { View, Text, StyleSheet, FlatList } from 'react-native';

import { connect } from "react-redux";

import { fetchLocation } from "../../actions/index"

const LocationScreen = (props) => {

    useEffect(() => {
        props.fetchLoc()
    }, [])

    return (<View style={styles.containerStyle} >
        <Text style={styles.textStyle} > Total number of locations :  {props.locList.length} </Text>


        <FlatList
            data={props.locList}
            keyExtractor={(result) => result.id}
            renderItem={({ item }) => {
                return (

                    <View style={styles.viewStyle}>
                        {/* <Text style={styles.textStyle}> Latitude : {item.latitude} </Text>
                        <Text style={styles.textStyle}> Longitude : {item.longitude} </Text>
                        <Text style={styles.textStyle}> Timestamp  : {item.receivedDate} </Text> */}
                        <View style={styles.insideView}><Text style={styles.textStyle}> Latitude : </Text>
                        <Text style={styles.addressText}> {item.latitude} </Text></View>
                        <View style={styles.insideView}><Text style={styles.textStyle}> Longitude : </Text>
                        <Text style={styles.addressText}> {item.longitude} </Text></View>
                        <View style={styles.insideView}><Text style={styles.textStyle}> Timestamp : </Text>
                        <Text style={styles.addressText}> {item.receivedDate} </Text></View>
                        <View style={styles.insideView}><Text style={styles.textStyle}> Address : </Text>
                        <Text style={styles.addressText}> {item.address} </Text>
                        </View>
                    </View>
                )
            }}
        />
    </View>);
}

const styles = StyleSheet.create({
    containerStyle: {
        // height : 50,
        backgroundColor: 'white',
    },

    viewStyle: {
        height: 150,
        // width: 280,
        marginTop: 10,
        backgroundColor: '#ccc',
        margin: 1,
        justifyContent: 'center',
        borderColor: "#ccc",
        borderRadius: 5
    },
    insideView: {
        flexDirection: 'row',
        width: 300,
    },
    addressText: {
        fontFamily: "Futura",
        fontSize: 15,
        textAlign: "auto",
        // marginLeft: 2,
        // marginRight: 
    },
    textStyle: {
        fontSize: 16,
        fontFamily: "Futura",
        textAlign: "auto",
        fontWeight: "bold",
        
    }

});



const mapStateToProps = (state) => {
    console.log("all loctions : " + state.locationsList.length)
    return {
        locList: state.locationsList
    }
}


const mapDispatchToProps = dispatch => {
    return {
        fetchLoc: () => dispatch(fetchLocation())
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(LocationScreen);
